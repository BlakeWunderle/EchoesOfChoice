using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;

namespace EchoesOfChoice.Battles
{
    public class CircusBattle : Battle
    {
        public CircusBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Harlequin() { CharacterName = "Louis" });
            Enemies.Add(new Chanteuse() { CharacterName = "Erembour" });
            Enemies.Add(new Ringmaster() { CharacterName = "Gaspard" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
                NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The performers crumple and the black walls shatter like glass, dissolving into nothing.");
            Console.WriteLine("Where the ringmaster fell a mirror lies face-up on the ground, perfectly clean among the dirt and debris.");
            Console.WriteLine("It catches the light in a way that shouldn't be possible. Something about it demands attention.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            if (PreviousBattleName == nameof(BeachBattle))
                Console.WriteLine("The trail leads north from the coast, winding through rolling hills with the sound of distant music growing louder. It seems peaceful enough until everyone suddenly hits something. An invisible wall.");
            else
                Console.WriteLine("The path east from the cave threads through wooded hills. Quiet, unremarkable terrain — until everyone suddenly hits something. An invisible wall.");
            Console.WriteLine("They turn left, then right, and finally turn back but they're boxed in. Something is trapping them and they can't see what.");
            Console.WriteLine("The air around them begins to darken, the invisible walls turning black as ink.");
            Console.WriteLine("Their attackers reveal themselves with smiles far too wide for comfort.");
        }
    }
}
