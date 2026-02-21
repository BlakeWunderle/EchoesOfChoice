using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ReturnToCityBattle4 : Battle
    {
        private List<BaseFighter> selectableEnemies = new List<BaseFighter>();

        public ReturnToCityBattle4(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Shaman() { CharacterName = "Sila" },
                new Warlock() { CharacterName = "Alis" }
            };

            foreach (var unit in Enemies)
            {
                var selectableEnemy = unit.Clone();
                selectableEnemy.IsUserControlled = true;
                selectableEnemies.Add(selectableEnemy);
            }

            var sila = selectableEnemies[0];
            sila.Health -= 22; sila.MaxHealth -= 22;
            sila.MagicAttack -= 6; sila.PhysicalAttack -= 3;

            var alis = selectableEnemies[1];
            alis.Health += 22; alis.MaxHealth += 22;
            alis.MagicAttack += 4; alis.PhysicalAttack += 6;

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ElementalBattle4(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("They lower their guard, satisfied. 'You are ready for what comes next.'");
            Console.WriteLine("Both step forward, offering to join the fight. But only one can accompany the party.");
            for (int i = 1; i <= selectableEnemies.Count; i++)
            {
                var enemy = selectableEnemies[i - 1];
                Console.WriteLine($"{i}. {enemy.CharacterName} the {enemy.CharacterType}");
            }
            Console.WriteLine("Type the number of the ally you would like and press enter.");

            BaseFighter selectedUnit = null;
            while (selectedUnit == null)
            {
                var unitNumber = (Console.ReadLine() ?? "").Trim();
                if (int.TryParse(unitNumber, out int selectedUnitNumber)
                    && selectedUnitNumber >= 1
                    && selectedUnitNumber <= selectableEnemies.Count)
                {
                    selectedUnit = selectableEnemies[selectedUnitNumber - 1];
                }
                else
                {
                    Console.WriteLine("That's not a valid selection. Try again.");
                }
            }
            Units.Add(selectedUnit);

            Console.WriteLine($"{selectedUnit.CharacterName} the {selectedUnit.CharacterType} joins the party!");

            foreach (var unit in Units)
            {
                unit.IncreaseLevel();
            }
        }

        public override void PreBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The party rushes back to the city. Smoke rises from the rooftops and the streets are emptier than when they left.");
            Console.WriteLine("The ground trembles beneath their feet. Whatever is coming, it's close.");
            Console.WriteLine("A familiar voice cuts through the chaos. 'You have proven yourself.'");
            Console.WriteLine("A second voice, eerily similar to the first, adds, 'We will help, after you pass our final test.'");
            Console.WriteLine("The stranger who sent them on this journey steps out from the shadows and pulls back her hood.");
            Console.WriteLine("Beside her stands her brother, doing the same.");
            Console.WriteLine("One communes with ancient spirits, calling upon ancestral guardians. The other crackles with forbidden dark power.");
            Console.WriteLine("They ready themselves and the final test begins.");
        }
    }
}
