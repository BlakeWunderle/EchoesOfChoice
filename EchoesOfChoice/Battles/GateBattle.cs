using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class GateBattle : Battle
    {
        public GateBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new DarkKnight() { CharacterName = "Ser Malachar" });
            Enemies.Add(new FellHound() { CharacterName = "Duskfang" });
            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new StrangerFinalBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The dark knight falls and the fell hound evaporates. The sigils on the gate crack and fade.");
            Console.WriteLine("Beyond lies a passage leading down — to wherever the stranger has gone to complete their work. The sanctum.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The old city gate has been sealed with dark sigils — the same symbol from the forest, from the tower.");
            Console.WriteLine("A knight in blackened armor stands before it, sword drawn. At his side, a hound made of shadow growls with a sound like tearing cloth.");
            Console.WriteLine("The stranger's last guardians.");
        }
    }
}
