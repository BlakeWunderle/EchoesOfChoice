using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using EchoesOfChoice.CharacterClasses.Enemies;

namespace EchoesOfChoice.Battles
{
    public class CemeteryBattle : Battle
    {
        public CemeteryBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();
            Enemies.Add(new Zombie() { CharacterName = "Mort--" });
            Enemies.Add(new Zombie() { CharacterName = "Rave--" });
            Enemies.Add(new Zombie() { CharacterName = "Jori--" });

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
                NextBattle = new MirrorBattle(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The zombies collapse back into the earth and the cemetery goes quiet. Even the wind stops.");
            Console.WriteLine("The fog begins to lift and among the tombstones something catches the light.");
            Console.WriteLine("A mirror, propped against a weathered headstone, perfectly clean as if someone placed it there on purpose.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Leaving the coast behind, the party follows the fog-covered path to the south.");
            Console.WriteLine("The mist thickens with every step until the adventurers can barely see each other.");
            Console.WriteLine("When it finally thins they find themselves standing in a cemetery. The air smells of damp earth and something old.");
            Console.WriteLine("Three graves have some writing on them and they read Mort--, Rave--, and Jori--.");
            Console.WriteLine($"A hand reaches up from the ground and gets a hold of {Units[0].CharacterName}.");
        }
    }
}
