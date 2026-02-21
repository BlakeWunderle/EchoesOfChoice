using EchoesOfChoice.Battles;
using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace EchoesOfChoice.BattleSimulator
{
    public class SimulationRunner
    {
        public int SimulationsPerCombo { get; set; } = 1000;
        public double Tolerance { get; set; } = 0.03;
        public int? SampleSize { get; set; }

        public const int MinTotalBattles = 200_000;
        private const int MinSimsPerCombo = 40;

        public static int CalculateSimsForPartyCount(int partyCount)
        {
            if (partyCount <= 0) return MinSimsPerCombo;
            return Math.Max(MinSimsPerCombo, (int)Math.Ceiling((double)MinTotalBattles / partyCount));
        }

        public List<BattleStageResult> RunAllSimulations()
        {
            var stages = BattleStage.GetAllStages();
            var results = new List<BattleStageResult>();

            foreach (var stage in stages)
            {
                Console.WriteLine($"\n{"=",-60}");
                Console.WriteLine($"  SIMULATING: {stage.Name}");
                Console.WriteLine($"{"=",-60}");

                var stageResult = SimulateStage(stage);
                results.Add(stageResult);

                PrintStageResult(stageResult);
            }

            return results;
        }

        public BattleStageResult SimulateStage(BattleStage stage)
        {
            var parties = stage.PartySource();
            if (SampleSize.HasValue)
                parties = PartyComposer.SampleParties(parties, SampleSize.Value);
            var comboResults = new ConcurrentBag<ComboResult>();
            var sw = Stopwatch.StartNew();

            Battle.IsSilent = true;
            try
            {
                Parallel.ForEach(parties, new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount }, party =>
                {
                    int wins = 0;
                    for (int i = 0; i < SimulationsPerCombo; i++)
                    {
                        var units = party.CreateParty(stage.LevelUps);
                        var battle = stage.BattleFactory(units);
                        bool gameOver = battle.BeginBattle();

                        if (!gameOver)
                            wins++;
                    }

                    comboResults.Add(new ComboResult
                    {
                        PartyDescription = party.Description,
                        Wins = wins,
                        Losses = SimulationsPerCombo - wins,
                        Total = SimulationsPerCombo,
                        WinRate = (double)wins / SimulationsPerCombo
                    });
                });
            }
            finally
            {
                Battle.IsSilent = false;
            }

            sw.Stop();
            var resultsList = comboResults.OrderBy(r => r.WinRate).ToList();

            return new BattleStageResult
            {
                StageName = stage.Name,
                TargetWinRate = stage.TargetWinRate,
                ProgressionStage = stage.ProgressionStage,
                ComboResults = resultsList,
                OverallWinRate = resultsList.Average(r => r.WinRate),
                ElapsedMs = sw.ElapsedMilliseconds
            };
        }

        /// <summary>
        /// Flattens all (stage, combo) pairs into a single parallel work queue for maximum
        /// CPU utilization. Eliminates idle time between sequential stage boundaries.
        /// </summary>
        public List<BattleStageResult> SimulateMultipleStages(List<BattleStage> stages, bool autoSims)
        {
            var stageInfos = new List<(BattleStage stage, List<PartyDefinition> parties, int sims)>();
            foreach (var stage in stages)
            {
                var parties = stage.PartySource();
                if (SampleSize.HasValue)
                    parties = PartyComposer.SampleParties(parties, SampleSize.Value);
                int sims = autoSims
                    ? CalculateSimsForPartyCount(parties.Count)
                    : SimulationsPerCombo;
                stageInfos.Add((stage, parties, sims));
            }

            var workItems = new List<(int stageIndex, BattleStage stage, PartyDefinition party, int sims)>();
            for (int si = 0; si < stageInfos.Count; si++)
            {
                var (stage, parties, sims) = stageInfos[si];
                foreach (var party in parties)
                    workItems.Add((si, stage, party, sims));
            }

            var resultBags = new ConcurrentBag<ComboResult>[stageInfos.Count];
            for (int i = 0; i < resultBags.Length; i++)
                resultBags[i] = new ConcurrentBag<ComboResult>();

            var sw = Stopwatch.StartNew();

            Battle.IsSilent = true;
            try
            {
                Parallel.ForEach(workItems, new ParallelOptions { MaxDegreeOfParallelism = Environment.ProcessorCount }, item =>
                {
                    int wins = 0;
                    for (int i = 0; i < item.sims; i++)
                    {
                        var units = item.party.CreateParty(item.stage.LevelUps);
                        var battle = item.stage.BattleFactory(units);
                        bool gameOver = battle.BeginBattle();
                        if (!gameOver) wins++;
                    }

                    resultBags[item.stageIndex].Add(new ComboResult
                    {
                        PartyDescription = item.party.Description,
                        Wins = wins,
                        Losses = item.sims - wins,
                        Total = item.sims,
                        WinRate = (double)wins / item.sims
                    });
                });
            }
            finally
            {
                Battle.IsSilent = false;
            }

            sw.Stop();

            return stageInfos.Select((info, idx) =>
            {
                var combos = resultBags[idx].OrderBy(r => r.WinRate).ToList();
                return new BattleStageResult
                {
                    StageName = info.stage.Name,
                    TargetWinRate = info.stage.TargetWinRate,
                    ProgressionStage = info.stage.ProgressionStage,
                    ComboResults = combos,
                    OverallWinRate = combos.Count > 0 ? combos.Average(r => r.WinRate) : 0,
                    ElapsedMs = sw.ElapsedMilliseconds
                };
            }).ToList();
        }

        private void PrintStageResult(BattleStageResult result)
        {
            var sampleNote = SampleSize.HasValue ? $" (sampled from full set)" : "";
            Console.WriteLine($"  Combos tested: {result.ComboResults.Count:N0}{sampleNote}");
            Console.WriteLine($"  Time: {result.ElapsedMs:N0}ms");
            Console.WriteLine($"  Overall win rate: {result.OverallWinRate:P1}");
            Console.WriteLine($"  Target: {result.TargetWinRate:P0} (+/- {Tolerance:P0})");

            PrintComboExtremes(result);
            PrintClassBreakdown(result);

            var status = GetStatus(result);
            Console.WriteLine($"\n  STATUS: {status}");
        }

        public void PrintComboExtremes(BattleStageResult result, int count = 5)
        {
            if (result.ComboResults.Count == 0) return;

            var sorted = result.ComboResults;
            var worst = sorted.Take(count).ToList();
            var best = sorted.TakeLast(count).ToList();
            var fullSpread = best.Last().WinRate - worst.First().WinRate;

            int p10Index = (int)(sorted.Count * 0.10);
            int p90Index = (int)(sorted.Count * 0.90);
            var p10 = sorted[Math.Min(p10Index, sorted.Count - 1)].WinRate;
            var p90 = sorted[Math.Min(p90Index, sorted.Count - 1)].WinRate;
            var coreSpread = p90 - p10;

            Console.WriteLine();
            Console.WriteLine($"  WEAKEST COMBOS:");
            foreach (var c in worst)
                Console.WriteLine($"    {c.WinRate:P1}  {c.PartyDescription}");

            Console.WriteLine();
            Console.WriteLine($"  STRONGEST COMBOS:");
            foreach (var c in best)
                Console.WriteLine($"    {c.WinRate:P1}  {c.PartyDescription}");

            Console.WriteLine();
            var coreVerdict = coreSpread switch
            {
                < 0.15 => "EXCELLENT",
                < 0.25 => "ACCEPTABLE",
                < 0.40 => "CONCERNING",
                _ => "CRITICAL"
            };
            Console.WriteLine($"  FULL SPREAD (min-max): {fullSpread:P1}");
            Console.WriteLine($"  CORE SPREAD (p10-p90): {coreSpread:P1} ({coreVerdict})  [p10={p10:P1}, p90={p90:P1}]");
        }

        public void PrintClassBreakdown(BattleStageResult result)
        {
            var classStats = new Dictionary<string, (int totalWins, int totalSims, int comboCount)>();

            foreach (var combo in result.ComboResults)
            {
                var classNames = combo.PartyDescription.Split(" / ");
                foreach (var className in classNames)
                {
                    if (!classStats.ContainsKey(className))
                        classStats[className] = (0, 0, 0);

                    var (w, s, c) = classStats[className];
                    classStats[className] = (w + combo.Wins, s + combo.Total, c + 1);
                }
            }

            var sorted = classStats
                .Select(kv => new { Class = kv.Key, WinRate = (double)kv.Value.totalWins / kv.Value.totalSims, kv.Value.comboCount })
                .OrderByDescending(x => x.WinRate)
                .ToList();

            Console.WriteLine();
            Console.WriteLine($"  {"CLASS BREAKDOWN:",-40}");
            Console.WriteLine($"    {"Class",-22} {"Win Rate",10} {"Combos",8}  {"Note",12}");
            Console.WriteLine($"    {new string('-', 54)}");

            var warningThreshold = result.TargetWinRate * 0.60;
            foreach (var entry in sorted)
            {
                var note = entry.WinRate < warningThreshold ? "** WEAK **" : "";
                Console.WriteLine($"    {entry.Class,-22} {entry.WinRate,10:P1} {entry.comboCount,8}  {note}");
            }
        }

        public string GetStatus(BattleStageResult result)
        {
            var low = result.TargetWinRate - Tolerance;
            var high = result.TargetWinRate + Tolerance;

            if (result.OverallWinRate >= low && result.OverallWinRate <= high)
                return "PASS";
            if (result.OverallWinRate < low)
                return "TOO HARD";
            return "TOO EASY";
        }

        public void PrintSummary(List<BattleStageResult> allResults)
        {
            Console.WriteLine($"\n\n{"=",-80}");
            Console.WriteLine("  SIMULATION SUMMARY");
            Console.WriteLine($"{"=",-80}");
            Console.WriteLine($"  {"Battle",-25} {"Win Rate",10} {"Target",10} {"Range",14} {"Status",12}");
            Console.WriteLine($"  {new string('-', 71)}");

            foreach (var r in allResults)
            {
                var low = r.TargetWinRate - Tolerance;
                var high = r.TargetWinRate + Tolerance;
                var range = $"{low:P0} - {high:P0}";
                var status = GetStatus(r);
                Console.WriteLine($"  {r.StageName,-25} {r.OverallWinRate,10:P1} {r.TargetWinRate,10:P0} {range,14} {status,12}");
            }

            var overallAvg = allResults.Average(r => r.OverallWinRate);
            var passCount = allResults.Count(r => GetStatus(r) == "PASS");
            Console.WriteLine($"\n  Passed: {passCount}/{allResults.Count}");
            Console.WriteLine($"  Average win rate: {overallAvg:P1}");
            Console.WriteLine($"  Tolerance: +/- {Tolerance:P0}");
        }
    }

    public class ComboResult
    {
        public string PartyDescription { get; set; }
        public int Wins { get; set; }
        public int Losses { get; set; }
        public int Total { get; set; }
        public double WinRate { get; set; }
    }

    public class BattleStageResult
    {
        public string StageName { get; set; }
        public double TargetWinRate { get; set; }
        public int ProgressionStage { get; set; }
        public List<ComboResult> ComboResults { get; set; }
        public double OverallWinRate { get; set; }
        public long ElapsedMs { get; set; }
    }
}
