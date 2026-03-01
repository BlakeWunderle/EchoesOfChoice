using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
namespace EchoesOfChoice.Battles
{
    public class MirrorBattle : Battle
    {
        public MirrorBattle(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>();

            foreach (var unit in Units)
            {
                var enemy = unit.Clone();
                enemy.CharacterName = "Shadow " + enemy.CharacterName;
                enemy.PhysicalAttack = (int)(enemy.PhysicalAttack * 0.98);
                enemy.MagicAttack = (int)(enemy.MagicAttack * 0.98);
                Enemies.Add(enemy);
            }

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new CityOutskirtsStop(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The shadow clones dissolve into smoke and are pulled back into the mirror.");
            Console.WriteLine("The surface ripples and cloudy letters slowly form across the glass: 'Return to the city.'");
            Console.WriteLine("The letters pulse with urgency. Something is wrong back home and whoever left this message knew it.");
            Console.WriteLine("The adventurers exchange a look. No more detours. Time to head back.");
            Console.WriteLine("Where is the stranger? They haven't been seen since before the mirror appeared. Come to think of it, every mirror they've found was placed too perfectly — as if someone knew exactly where they'd be.");
            Console.WriteLine("The stranger said the source of the darkness was beyond the forest. They went looking and found only chaos spreading from somewhere else.");
            Console.WriteLine("And now a mirror is pointing them home.");
            Console.WriteLine("The thought lands slowly, uncomfortably: maybe the source was never out here. Maybe it was always at the city.");
            Console.WriteLine("As they turn toward the city, something catches the eye. A faint smudge on the horizon where the skyline should be.");
            Console.WriteLine("Dark. Wrong. Moving.");
            Console.WriteLine("They run.");
            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("Picking up the mirror everyone looks into it. For a moment the reflections stare back a little too long.");
            var observer = Units.Count > 1 ? Units[1] : Units[0];
            Console.WriteLine($"{observer.CharacterName} notices dark clouds forming behind them and spins around.");
            Console.WriteLine("The clouds twist and solidify, taking the exact shape of the party. Same faces, same weapons, same stance.");
            Console.WriteLine("Fighting yourself. That's a new one.");
        }
    }
}
