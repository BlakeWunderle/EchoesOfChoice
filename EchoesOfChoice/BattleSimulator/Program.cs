using System;
using System.Diagnostics;
using System.Linq;

namespace EchoesOfChoice.BattleSimulator
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("=== Echoes of Choice Battle Simulator ===");
            Console.WriteLine();

            var stages = BattleStage.GetAllStages();
            var runner = new SimulationRunner
            {
                SimulationsPerCombo = 1000,
                Tolerance = 0.03
            };

            string stageName = null;
            bool runAll = false;
            bool autoSims = false;
            int? progressionFilter = null;
            bool simsExplicit = false;
            int? sampleSize = null;

            for (int i = 0; i < args.Length; i++)
            {
                if (args[i] == "--sims" && i + 1 < args.Length && int.TryParse(args[i + 1], out int sims))
                {
                    runner.SimulationsPerCombo = sims;
                    simsExplicit = true;
                    i++;
                }
                else if (args[i] == "--auto")
                {
                    autoSims = true;
                }
                else if (args[i] == "--all")
                {
                    runAll = true;
                }
                else if (args[i] == "--progression" && i + 1 < args.Length && int.TryParse(args[i + 1], out int prog))
                {
                    progressionFilter = prog;
                    i++;
                }
                else if (args[i] == "--sample" && i + 1 < args.Length && int.TryParse(args[i + 1], out int sample))
                {
                    sampleSize = sample;
                    i++;
                }
                else if (args[i] == "--list")
                {
                    PrintStageList(stages);
                    return;
                }
                else if (args[i] == "--help")
                {
                    PrintHelp();
                    return;
                }
                else if (!args[i].StartsWith("--"))
                {
                    stageName = args[i];
                }
            }

            if (autoSims && simsExplicit)
            {
                Console.WriteLine("Warning: --auto overrides --sims. Using auto-calculated sim counts.\n");
            }

            if (sampleSize.HasValue)
                runner.SampleSize = sampleSize;

            if (runAll)
            {
                if (autoSims)
                    Console.WriteLine($"Running AUTO sims/combo (min {SimulationRunner.MinTotalBattles:N0} total) for ALL {stages.Count} battles...\n");
                else
                    Console.WriteLine($"Running {runner.SimulationsPerCombo} sims/combo for ALL {stages.Count} battles...\n");

                var sw = Stopwatch.StartNew();
                var results = RunStagesWithAuto(runner, stages, autoSims);
                sw.Stop();

                runner.PrintSummary(results);
                Console.WriteLine($"\n  Total time: {sw.Elapsed.TotalSeconds:F1}s");
                return;
            }

            if (progressionFilter.HasValue)
            {
                var progStages = stages.Where(s => s.ProgressionStage == progressionFilter.Value).ToList();
                if (progStages.Count == 0)
                {
                    Console.WriteLine($"No battles found for progression stage {progressionFilter.Value}.\n");
                    PrintStageList(stages);
                    return;
                }

                if (autoSims)
                {
                    int fullCount = progStages.First().PartySource().Count;
                    int comboCount = sampleSize.HasValue ? Math.Min(sampleSize.Value, fullCount) : fullCount;
                    int autoCount = SimulationRunner.CalculateSimsForPartyCount(comboCount);
                    var sampleNote = sampleSize.HasValue && comboCount < fullCount ? $" (sampled from {fullCount:N0})" : "";
                    Console.WriteLine($"Progression {progressionFilter.Value}: {comboCount} party combos{sampleNote} -> {autoCount} sims/combo ({comboCount * autoCount:N0} total battles)");
                    Console.WriteLine($"Running for {progStages.Count} battles...\n");
                }
                else
                {
                    var sampleNote = sampleSize.HasValue ? $", sampled to {sampleSize.Value}" : "";
                    Console.WriteLine($"Running {runner.SimulationsPerCombo} sims/combo for Progression {progressionFilter.Value} ({progStages.Count} battles{sampleNote})...\n");
                }

                var sw = Stopwatch.StartNew();
                var results = RunStagesWithAuto(runner, progStages, autoSims);
                sw.Stop();

                runner.PrintSummary(results);
                foreach (var r in results)
                {
                    Console.WriteLine($"\n  --- {r.StageName} ---");
                    runner.PrintComboExtremes(r);
                    runner.PrintClassBreakdown(r);
                }
                Console.WriteLine($"\n  Time: {sw.Elapsed.TotalSeconds:F1}s");
                return;
            }

            if (stageName != null)
            {
                var stage = stages.FirstOrDefault(s =>
                    s.Name.Equals(stageName, StringComparison.OrdinalIgnoreCase));

                if (stage == null)
                {
                    Console.WriteLine($"Stage '{stageName}' not found.\n");
                    PrintStageList(stages);
                    return;
                }

                if (autoSims)
                {
                    int partyCount = stage.PartySource().Count;
                    runner.SimulationsPerCombo = SimulationRunner.CalculateSimsForPartyCount(partyCount);
                    Console.WriteLine($"  Auto: {partyCount} party combos -> {runner.SimulationsPerCombo} sims/combo ({partyCount * runner.SimulationsPerCombo:N0} total battles)");
                }

                RunSingleStage(runner, stage);
                return;
            }

            InteractiveMenu(runner, stages);
        }

        static void InteractiveMenu(SimulationRunner runner, System.Collections.Generic.List<BattleStage> stages)
        {
            Console.WriteLine($"Simulations per combo: {runner.SimulationsPerCombo}");
            Console.WriteLine($"Difficulty gradient: 90% (first) -> 60% (finale), +/- {runner.Tolerance:P0}\n");

            while (true)
            {
                Console.WriteLine("Select a battle to simulate (or 'quit' to exit):\n");
                for (int i = 0; i < stages.Count; i++)
                {
                    Console.WriteLine($"  {i + 1,2}. {stages[i].Name,-25} [target: {stages[i].TargetWinRate:P0}]");
                }

                Console.WriteLine($"\n  {"A",2}. Run ALL battles");
                Console.Write("\nChoice: ");
                var input = Console.ReadLine()?.Trim();

                if (string.IsNullOrEmpty(input) || input.Equals("quit", StringComparison.OrdinalIgnoreCase) ||
                    input.Equals("q", StringComparison.OrdinalIgnoreCase))
                    break;

                if (input.Equals("a", StringComparison.OrdinalIgnoreCase) ||
                    input.Equals("all", StringComparison.OrdinalIgnoreCase))
                {
                    var sw = Stopwatch.StartNew();
                    var results = runner.RunAllSimulations();
                    sw.Stop();
                    runner.PrintSummary(results);
                    Console.WriteLine($"\n  Total time: {sw.Elapsed.TotalSeconds:F1}s\n");
                    continue;
                }

                if (int.TryParse(input, out int choice) && choice >= 1 && choice <= stages.Count)
                {
                    RunSingleStage(runner, stages[choice - 1]);
                    Console.WriteLine();
                    continue;
                }

                var matched = stages.FirstOrDefault(s =>
                    s.Name.Equals(input, StringComparison.OrdinalIgnoreCase));
                if (matched != null)
                {
                    RunSingleStage(runner, matched);
                    Console.WriteLine();
                    continue;
                }

                Console.WriteLine("Invalid choice. Try a number, battle name, or 'quit'.\n");
            }
        }

        static void RunSingleStage(SimulationRunner runner, BattleStage stage)
        {
            Console.WriteLine($"\nRunning {runner.SimulationsPerCombo} sims/combo for {stage.Name}...");
            var sw = Stopwatch.StartNew();
            var result = runner.SimulateStage(stage);
            sw.Stop();

            runner.PrintSummary(new() { result });
            runner.PrintComboExtremes(result);
            runner.PrintClassBreakdown(result);
            Console.WriteLine($"\n  Time: {sw.Elapsed.TotalSeconds:F1}s");
        }

        static System.Collections.Generic.List<BattleStageResult> RunStagesWithAuto(
            SimulationRunner runner,
            System.Collections.Generic.List<BattleStage> stages,
            bool autoSims)
        {
            foreach (var stage in stages)
            {
                var parties = stage.PartySource();
                int comboCount = runner.SampleSize.HasValue
                    ? Math.Min(runner.SampleSize.Value, parties.Count)
                    : parties.Count;
                int sims = autoSims
                    ? SimulationRunner.CalculateSimsForPartyCount(comboCount)
                    : runner.SimulationsPerCombo;
                var sampleNote = runner.SampleSize.HasValue && comboCount < parties.Count
                    ? $" (sampled from {parties.Count:N0})"
                    : "";
                Console.WriteLine($"  {stage.Name}: {comboCount:N0} combos{sampleNote} x {sims:N0} sims = {comboCount * sims:N0} battles");
            }
            Console.WriteLine();

            return runner.SimulateMultipleStages(stages, autoSims);
        }

        static void PrintStageList(System.Collections.Generic.List<BattleStage> stages)
        {
            Console.WriteLine($"  {"Battle",-25} {"Stage",6} {"Target",8}");
            Console.WriteLine($"  {new string('-', 41)}");
            for (int i = 0; i < stages.Count; i++)
            {
                Console.WriteLine($"  {stages[i].Name,-25} {stages[i].ProgressionStage,6} {stages[i].TargetWinRate,8:P0}");
            }
        }

        static void PrintHelp()
        {
            Console.WriteLine("Usage: BattleSimulator [options] [stage-name]\n");
            Console.WriteLine("Options:");
            Console.WriteLine("  --sims <n>           Simulations per combo (default: 1000)");
            Console.WriteLine("  --auto               Auto-calculate sims to hit 200k+ total battles");
            Console.WriteLine("  --sample <n>         Use stratified sample of n party combos (faster iteration)");
            Console.WriteLine("  --progression <n>    Run all battles in a progression stage");
            Console.WriteLine("  --all                Run all battles sequentially");
            Console.WriteLine("  --list               List available battle stages");
            Console.WriteLine("  --help               Show this help\n");
            Console.WriteLine("Auto mode sims by tier:");
            Console.WriteLine("  Base (20 combos)      -> 10,000 sims/combo = 200k battles");
            Console.WriteLine("  Tier 1 (560 combos)   ->    360 sims/combo = 201k battles");
            Console.WriteLine("  Tier 2 (4960 combos)  ->     41 sims/combo = 203k battles");
            Console.WriteLine("  T2+Recruit (9920)     ->     40 sims/combo = 397k battles\n");
            Console.WriteLine("Examples:");
            Console.WriteLine("  BattleSimulator CityStreetBattle");
            Console.WriteLine("  BattleSimulator --sims 500 ForestBattle");
            Console.WriteLine("  BattleSimulator --auto --progression 2");
            Console.WriteLine("  BattleSimulator --auto --all");
            Console.WriteLine("  BattleSimulator --sims 200 --all");
            Console.WriteLine("  BattleSimulator --sample 500 --sims 50 --progression 4");
            Console.WriteLine("  BattleSimulator                          (interactive menu)");
        }
    }
}
