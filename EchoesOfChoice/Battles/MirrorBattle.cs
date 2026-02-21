using EchoesOfChoice.CharacterClasses.Common;
using System;
using System.Collections.Generic;
using System.Linq;

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
            var random = new Random();
            var nextBattleInt = random.Next(1, 19);

            switch(nextBattleInt)
            {
                case 1 :
                case 2 :
                case 3 :
                    {
                        NextBattle = new ReturnToCityBattle1(Units);
                        break;
                    }
                case 4:
                case 5:
                case 6:
                case 7:
                case 8:
                    {
                        NextBattle = new ReturnToCityBattle2(Units);
                        break;
                    }
                case 9:
                case 10:
                case 11:
                case 12:
                case 13:
                    {
                        NextBattle = new ReturnToCityBattle3(Units);
                        break;
                    }
                case 14:
                case 15:
                case 16:
                case 17:
                case 18:
                    {
                        NextBattle = new ReturnToCityBattle4(Units);
                        break;
                    }
                default:
                    {
                        NextBattle = new ReturnToCityBattle2(Units);
                        break;
                    }
            }
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The shadow clones dissolve into smoke and are pulled back into the mirror.");
            Console.WriteLine("The surface ripples and cloudy letters slowly form across the glass: 'Return to the city.'");
            Console.WriteLine("The letters pulse with urgency. Something is wrong back home and whoever left this message knew it.");
            Console.WriteLine("The adventurers exchange a look. No more detours. Time to head back.");
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
