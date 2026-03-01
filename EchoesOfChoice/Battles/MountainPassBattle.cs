using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class MountainPassBattle : Battle
    {
        public MountainPassBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Troll() { CharacterName = "Grendal" });
            Enemies.Add(new Harpy() { CharacterName = "Screecher" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new WildernessOutpost(Units);
            NextBattle.PreviousBattleName = GetType().Name;
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The troll loses its footing and tumbles into the ravine with a fading roar. The harpy shrieks and flees into the clouds.");
            Console.WriteLine("Beyond the pass the land drops into a wide valley. Smoke from cooking fires marks an outpost ahead.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The mountain pass narrows to barely a single track wide. A bridge of ancient stone spans a deep ravine, the bottom lost in mist.");
            Console.WriteLine("Halfway across, a troll lumbers out from under the bridge. Its skin is the color of wet rock and its eyes burn a dull orange.");
            Console.WriteLine("Above, a harpy circles and shrieks, diving and pulling up, testing the party's nerve.");
            Console.WriteLine("No way around. Only through.");
        }
    }
}
