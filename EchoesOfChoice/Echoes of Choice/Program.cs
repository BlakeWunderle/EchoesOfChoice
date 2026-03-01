using EchoesOfChoice.CharacterClasses.Fighter;
using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.Battles;
using EchoesOfChoice.Battles.SaveSystem;
using EchoesOfChoice.CharacterClasses.Mage;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Entertainer;
using System;
using EchoesOfChoice.CharacterClasses.Scholar;
using EchoesOfChoice.CharacterClasses.Wildling;
using EchoesOfChoice.CharacterClasses.Enemies;
using System.Linq;

namespace EchoesOfChoice
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                Battle battle;

                var menuChoice = ShowTitleScreen();

                if (menuChoice == "quit")
                    return;

                if (menuChoice == "continue")
                {
                    var saveData = SaveManager.Load();
                    if (saveData != null)
                    {
                        var units = saveData.Party
                            .Select(f => FighterFactory.CreateFighter(f))
                            .ToList();
                        battle = BattleFactory.CreateBattle(saveData.CurrentBattle, units);
                        Console.WriteLine();
                        Console.WriteLine("Save loaded. Resuming your adventure...");
                        Pause();
                    }
                    else
                    {
                        Console.WriteLine("Starting a new game instead.");
                        Pause();
                        battle = new CityStreetBattle(CreateParty());
                    }
                }
                else
                {
                    if (SaveManager.HasSaveFile())
                        SaveManager.DeleteSave();
                    battle = new CityStreetBattle(CreateParty());
                }

                var gameOver = false;

                while (!battle.IsFinalBattle && !gameOver)
                {
                    battle.PreBattleInteraction();
                    Pause();
                    gameOver = battle.BeginBattle();
                    if (!gameOver)
                    {
                        battle.PostBattleInteraction();
                        Pause();
                        battle.DetermineNextBattle();
                        SaveManager.Save(battle.NextBattle, battle.Units);
                        battle = battle.NextBattle;
                    }
                }

                if (!gameOver)
                {
                    battle.PreBattleInteraction();
                    Pause();
                    gameOver = battle.BeginBattle();
                    if (!gameOver)
                    {
                        battle.PostBattleInteraction();
                        Pause();
                    }
                }

                SaveManager.DeleteSave();

                Console.WriteLine();
                if (gameOver)
                {
                    Console.WriteLine("Our heroes fall and the darkness grows a little stronger.");
                    Console.WriteLine("This journey may be over, but every great story deserves another telling.");
                }
                else
                {
                    Console.WriteLine("The stranger is gone and with them, the shadow that covered the land.");
                    Console.WriteLine("The sky clears. The city stirs. People emerge from hiding.");
                    Console.WriteLine("It will take time, but the world will heal.");
                    Console.WriteLine("Our heroes stand in the light, bruised and exhausted and alive.");
                    Console.WriteLine("Every choice left an echo, and theirs will ring through the ages.");
                    Console.WriteLine();
                    Console.WriteLine("Thank you for playing Echoes of Choice.");
                }

                Console.WriteLine();
                Console.ForegroundColor = ConsoleColor.DarkGray;
                Console.Write("Press any key to exit...");
                Console.ResetColor();
                Console.ReadKey(true);
            }
            catch (Exception e)
            {
                Console.WriteLine();
                Console.WriteLine(e.Message);
                Console.WriteLine(e.StackTrace);
                Console.ReadKey();
            }
        }

        private static string ShowTitleScreen()
        {
            Console.Clear();
            Console.WriteLine();
            Console.WriteLine(@"  ╔═══════════════════════════════════════════════════════════════╗");
            Console.WriteLine(@"  ║                                                               ║");
            Console.WriteLine(@"  ║     ███████╗ ██████╗██╗  ██╗ ██████╗ ███████╗███████╗         ║");
            Console.WriteLine(@"  ║     ██╔════╝██╔════╝██║  ██║██╔═══██╗██╔════╝██╔════╝         ║");
            Console.WriteLine(@"  ║     █████╗  ██║     ███████║██║   ██║█████╗  ███████╗         ║");
            Console.WriteLine(@"  ║     ██╔══╝  ██║     ██╔══██║██║   ██║██╔══╝  ╚════██║         ║");
            Console.WriteLine(@"  ║     ███████╗╚██████╗██║  ██║╚██████╔╝███████╗███████║         ║");
            Console.WriteLine(@"  ║     ╚══════╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝         ║");
            Console.WriteLine(@"  ║                                                               ║");
            Console.WriteLine(@"  ║                ██████╗ ███████╗                               ║");
            Console.WriteLine(@"  ║               ██╔═══██╗██╔════╝                               ║");
            Console.WriteLine(@"  ║               ██║   ██║█████╗                                 ║");
            Console.WriteLine(@"  ║               ██║   ██║██╔══╝                                 ║");
            Console.WriteLine(@"  ║               ╚██████╔╝██║                                    ║");
            Console.WriteLine(@"  ║                ╚═════╝ ╚═╝                                    ║");
            Console.WriteLine(@"  ║                                                               ║");
            Console.WriteLine(@"  ║    ██████╗██╗  ██╗ ██████╗ ██╗ ██████╗███████╗                ║");
            Console.WriteLine(@"  ║   ██╔════╝██║  ██║██╔═══██╗██║██╔════╝██╔════╝                ║");
            Console.WriteLine(@"  ║   ██║     ███████║██║   ██║██║██║     █████╗                  ║");
            Console.WriteLine(@"  ║   ██║     ██╔══██║██║   ██║██║██║     ██╔══╝                  ║");
            Console.WriteLine(@"  ║   ╚██████╗██║  ██║╚██████╔╝██║╚██████╗███████╗                ║");
            Console.WriteLine(@"  ║    ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝ ╚═════╝╚══════╝                ║");
            Console.WriteLine(@"  ║                                                               ║");
            Console.WriteLine(@"  ║           Every choice leaves an echo...                      ║");
            Console.WriteLine(@"  ║                                                               ║");
            Console.WriteLine(@"  ╚═══════════════════════════════════════════════════════════════╝");
            Console.WriteLine();

            bool hasSave = SaveManager.HasSaveFile();

            Console.WriteLine("  ┌─────────────────────┐");
            Console.WriteLine("  │  1. New Game         │");
            if (hasSave)
                Console.WriteLine("  │  2. Continue         │");
            Console.WriteLine("  │  3. Quit             │");
            Console.WriteLine("  └─────────────────────┘");
            Console.WriteLine();

            while (true)
            {
                Console.Write("  Choose an option: ");
                var input = (Console.ReadLine() ?? "").Trim();

                switch (input)
                {
                    case "1":
                        return "new";
                    case "2" when hasSave:
                        return "continue";
                    case "3":
                        return "quit";
                    default:
                        Console.WriteLine("  That's not a valid option. Try again.");
                        break;
                }
            }
        }

        private static List<BaseFighter> CreateParty()
        {
            Console.WriteLine("The Copper Mug. Your regular haunt. You know every crack in the floorboards, every stain on the bar.");
            Console.WriteLine("But tonight something is different. The fire burns low without anyone stoking it. The other regulars have gone quiet.");
            Console.WriteLine("A shrouded stranger sits in the corner booth — a booth that was empty a moment ago.");
            Console.WriteLine("The air feels heavy. Wrong. Like the room itself is holding its breath.");
            Console.WriteLine("The stranger catches your eye and waves you over.");
            Console.WriteLine("'What is your name, young warrior?'");
            var name = ReadName();

            Console.WriteLine($"'Greetings, {name}. You look like someone who can handle themselves.'");

            BaseFighter player1 = ChooseClass(name);

            Console.WriteLine();
            Console.WriteLine("Shortly after, another warrior overhears the conversation and slides into the booth.");
            Console.WriteLine("The stranger looks them over and asks the same question.");
            Console.WriteLine("'And what is your name?'");
            name = ReadName();

            Console.WriteLine($"'Greetings, {name}. Good, we'll need the help.'");

            BaseFighter player2 = ChooseClass(name);

            Console.WriteLine();
            Console.WriteLine("One last warrior takes a seat at the now crowded table.");
            Console.WriteLine("The stranger doesn't even hesitate.");
            Console.WriteLine("'And you? What is your name?'");
            name = ReadName();

            Console.WriteLine($"'Greetings, {name}. That makes three. That should be enough.'");

            BaseFighter player3 = ChooseClass(name);

            Console.WriteLine();
            Console.WriteLine("The stranger leans in close, voice barely above a whisper.");
            Console.WriteLine("'Something evil has taken root beyond the forest. The city needs heroes whether it knows it or not.'");
            Console.WriteLine("'Find the source. End it. I'll be watching — and I'll find you when the time is right.'");
            Console.WriteLine("The stranger raises a glass but doesn't drink — just holds it, watching the liquid catch the firelight.");
            Console.WriteLine("Then they set it down, untouched, and disappear into the crowd. The coin left on the table is gold. Blank on one side.");

            Pause();

            return new List<BaseFighter>() { player1, player2, player3 };
        }

        private static void Pause()
        {
            if (Battle.IsSilent) return;
            Console.WriteLine();
            Console.ForegroundColor = ConsoleColor.DarkGray;
            Console.Write("Press any key to continue...");
            Console.ResetColor();
            Console.ReadKey(true);
            Console.WriteLine();
        }

        private static string ReadName()
        {
            while (true)
            {
                var name = (Console.ReadLine() ?? "").Trim();
                if (!string.IsNullOrEmpty(name))
                    return name;
                Console.WriteLine("Please enter a name.");
            }
        }

        private static BaseFighter ChooseClass(string name)
        {
            Console.WriteLine();
            Console.WriteLine("What is your calling?");
            Console.WriteLine();
            Console.WriteLine("  1. Squire      - A sturdy warrior who fights with steel and shield.");
            Console.WriteLine("  2. Mage        - A wielder of arcane forces and elemental magic.");
            Console.WriteLine("  3. Entertainer  - A charismatic performer who inspires allies.");
            Console.WriteLine("  4. Tinker      - A brilliant mind who turns knowledge into power.");
            Console.WriteLine("  5. Wildling    - A primal soul who communes with nature and beasts.");

            while (true)
            {
                Console.WriteLine();
                Console.WriteLine("Type the number of your class and press enter.");
                var input = (Console.ReadLine() ?? "").Trim();

                BaseFighter chosen = null;
                switch (input)
                {
                    case "1": chosen = new Squire() { CharacterName = name, IsUserControlled = true }; break;
                    case "2": chosen = new Mage() { CharacterName = name, IsUserControlled = true }; break;
                    case "3": chosen = new Entertainer() { CharacterName = name, IsUserControlled = true }; break;
                    case "4": chosen = new Scholar() { CharacterName = name, IsUserControlled = true }; break;
                    case "5": chosen = new EchoesOfChoice.CharacterClasses.Wildling.Wildling() { CharacterName = name, IsUserControlled = true }; break;
                    default:
                        Console.WriteLine("That's not a valid class. Try again.");
                        continue;
                }

                Console.WriteLine($"{name} the {chosen.CharacterType} joins the party!");
                return chosen;
            }
        }
    }
}
