using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ForestWaypoint : Battle
    {
        public ForestWaypoint(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            IsFinalBattle = false;
            IsTownStop = true;
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("A small waypoint inn appears where the forest trails converge, barely holding itself together. The sign over the door reads 'The Wanderer's Rest.'");
            Console.WriteLine("The innkeeper, a weathered woman who looks like she hasn't slept in weeks, leans on the counter.");
            Console.WriteLine("'Don't get many travelers with enough sense to stop here anymore.'");
            Console.WriteLine("'West of here the smoke's been burning for days. Things moving around it. Not woodsmen.'");
            Console.WriteLine("'North, the old growth gets dark fast. Someone's been putting up circles of stones and sticks. Witch work, if you believe in that.'");
            Console.WriteLine("'East there's music drifting through the trees. Three travelers went to find it. None came back.'");
            Console.WriteLine("'Southeast takes you to the rocky shore. The singing from the water isn't safe. Never was.'");
            Console.WriteLine("'Southwest, the old ruins have been glowing at night again. Cold light. The wrong kind.'");
            Console.WriteLine("She refills her cup. 'A stranger passed through last week. Said the source of it all was out here somewhere — didn't say where. Paid in gold that turned out to be blank on one side.'");
            Console.WriteLine("'You're all looking for the same thing. I hope you find it before it finds you.'");
        }

        public override void PostBattleInteraction() { }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();
            Console.WriteLine("Five paths lead out from the crossroads:");
            Console.WriteLine("  [Smoke]    A column of smoke curls above the canopy to the west. Campfire, maybe. Or something worse.");
            Console.WriteLine("  [Forest]   The trees grow older and darker to the north. The light barely reaches the ground.");
            Console.WriteLine("  [Clearing] Music drifts from the east — faint, but unmistakably there.");
            Console.WriteLine("  [Shore]    Salt in the air and the sound of surf to the southeast.");
            Console.WriteLine("  [Ruins]    A faint glow pulses somewhere among ancient stones to the southwest.");

            while (NextBattle == null)
            {
                Console.WriteLine("Please type 'Smoke', 'Forest', 'Clearing', 'Shore', or 'Ruins' and press enter.");
                var nextBattle = (Console.ReadLine() ?? "").ToLower().Trim();

                switch (nextBattle)
                {
                    case "smoke":
                        NextBattle = new SmokeBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "forest":
                        NextBattle = new DeepForestBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "clearing":
                        NextBattle = new ClearingBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "shore":
                        NextBattle = new ShoreBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    case "ruins":
                        NextBattle = new RuinsBattle(Units);
                        NextBattle.PreviousBattleName = GetType().Name;
                        break;
                    default:
                        Console.WriteLine("That's not a valid path. Try again.");
                        break;
                }
            }
        }
    }
}
