using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class HighlandBattle : Battle
    {
        public HighlandBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Raider() { CharacterName = "Wulfric" });
            Enemies.Add(new Raider() { CharacterName = "Bjorn" });
            Enemies.Add(new Orc() { CharacterName = "Grath" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new MountainPassBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The raider stumbles back and the orc grunts, dragging him up the mountain path. They disappear around a bend without looking back.");
            Console.WriteLine("The highlands open ahead into a narrow pass, the wind howling through the gap between sheer rock walls.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The western trail climbs into the highlands, rocky and wind-battered. Cairns of piled stone mark the path at uneven intervals.");
            Console.WriteLine("A raider steps out from behind a cairn, arms crossed, blocking the trail. An orc looms behind him, half again as tall and twice as wide.");
            Console.WriteLine("'Tribute,' the raider says. 'Everything you've got. Or we take it off your corpses.'");
            Console.WriteLine("The party has a different idea.");
        }
    }
}
