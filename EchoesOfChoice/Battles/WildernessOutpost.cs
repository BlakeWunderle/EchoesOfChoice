using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class WildernessOutpost : Battle
    {
        public WildernessOutpost(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            IsFinalBattle = false;
            IsTownStop = true;
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Through a break in the trees the party spots a cluster of tents and wagons — people moving away from the city, not toward it.");
            Console.WriteLine("A young scout sits apart from the others, watching the road. He waves them over.");
            Console.WriteLine("'You came from deeper in? Good. You're still alive, that's something.'");
            Console.WriteLine("'Three weeks ago things started getting strange back in the city. Market district went quiet overnight. Animals started fleeing.'");
            Console.WriteLine("'Then the fog came. Cold, wrong-smelling fog rolling out in every direction. People started leaving.'");
            Console.WriteLine("'I've got people back there. I'm not running. But I've been watching the roads, and I'll tell you what I've seen.'");

            if (PreviousBattleName == nameof(PortalBattle))
            {
                Console.WriteLine("'North of here there's a building that's been humming for a month. I don't know what's inside. South — a military encampment. Big one. They showed up right when the fog did.'");
            }
            else if (PreviousBattleName == nameof(CaveBattle))
            {
                Console.WriteLine("'East of here I keep hearing music and laughter through the trees. No one's set up any kind of camp out there. West, a building with lights that shouldn't be there. Neither one was here a month ago.'");
            }
            else
            {
                Console.WriteLine("'Inland to the north the music's been getting louder. Something drawing people in. South the fog is thickest — there's a path through the hills that smells like old earth and something worse.'");
            }

            Console.WriteLine("He looks toward the city in the distance. 'Whatever's happening, it's not starting out here. It's starting there. You're all just catching the edges of it.'");
            Console.WriteLine("'City's that way. Whatever you find out here — if you make it back, make it count.'");
        }

        public override void PostBattleInteraction() { }

        public override void DetermineNextBattle()
        {
            Console.WriteLine();

            if (PreviousBattleName == nameof(PortalBattle))
            {
                Console.WriteLine("Two paths lead onward from the outpost:");
                Console.WriteLine("  [Static]  To the north, an unnatural charge in the air. Something metallic on the horizon.");
                Console.WriteLine("  [Camp]    To the south, the tramp of marching boots and a barking voice echo across the plain.");

                while (NextBattle == null)
                {
                    Console.WriteLine("Please type 'Static' or 'Camp' and press enter.");
                    var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                    switch (choice)
                    {
                        case "static":
                            NextBattle = new LabBattle(Units);
                            NextBattle.PreviousBattleName = nameof(PortalBattle);
                            break;
                        case "camp":
                            NextBattle = new ArmyBattle(Units);
                            NextBattle.PreviousBattleName = nameof(PortalBattle);
                            break;
                        default:
                            Console.WriteLine("That's not a valid choice. Try again.");
                            break;
                    }
                }
            }
            else if (PreviousBattleName == nameof(CaveBattle))
            {
                Console.WriteLine("Two paths lead onward from the outpost:");
                Console.WriteLine("  [Laughter]  To the east, laughter and music drift through the trees. Whatever's making that sound isn't small.");
                Console.WriteLine("  [Hum]       To the west, an unnatural energy pulses in the dark. Something mechanical, not quite magic.");

                while (NextBattle == null)
                {
                    Console.WriteLine("Please type 'Laughter' or 'Hum' and press enter.");
                    var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                    switch (choice)
                    {
                        case "laughter":
                            NextBattle = new CircusBattle(Units);
                            NextBattle.PreviousBattleName = nameof(CaveBattle);
                            break;
                        case "hum":
                            NextBattle = new LabBattle(Units);
                            NextBattle.PreviousBattleName = nameof(CaveBattle);
                            break;
                        default:
                            Console.WriteLine("That's not a valid choice. Try again.");
                            break;
                    }
                }
            }
            else // BeachBattle
            {
                Console.WriteLine("Two paths lead onward from the outpost:");
                Console.WriteLine("  [Music]  Inland to the north, laughter and music filter through the trees.");
                Console.WriteLine("  [Fog]    To the south, a fog-covered path winds into rolling hills. The air smells of damp earth and something older.");

                while (NextBattle == null)
                {
                    Console.WriteLine("Please type 'Music' or 'Fog' and press enter.");
                    var choice = (Console.ReadLine() ?? "").ToLower().Trim();
                    switch (choice)
                    {
                        case "music":
                            NextBattle = new CircusBattle(Units);
                            NextBattle.PreviousBattleName = nameof(BeachBattle);
                            break;
                        case "fog":
                            NextBattle = new CemeteryBattle(Units);
                            NextBattle.PreviousBattleName = nameof(BeachBattle);
                            break;
                        default:
                            Console.WriteLine("That's not a valid choice. Try again.");
                            break;
                    }
                }
            }
        }
    }
}
