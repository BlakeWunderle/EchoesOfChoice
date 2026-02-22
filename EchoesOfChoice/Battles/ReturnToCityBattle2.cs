using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ReturnToCityBattle2 : Battle
    {
        private List<BaseFighter> selectableEnemies = new List<BaseFighter>();

        public ReturnToCityBattle2(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Druid() { CharacterName = "Nira" },
                new Necromancer() { CharacterName = "Arin" }
            };

            foreach (var unit in Enemies)
            {
                var selectableEnemy = unit.Clone();
                selectableEnemy.IsUserControlled = true;
                selectableEnemies.Add(selectableEnemy);
            }

            var nira = selectableEnemies[0];
            nira.Health -= 18; nira.MaxHealth -= 18;
            nira.MagicAttack -= 6; nira.PhysicalAttack -= 4;

            var arin = selectableEnemies[1];
            arin.Health += 18; arin.MaxHealth += 18;
            arin.MagicAttack += 4; arin.PhysicalAttack += 6;

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ElementalBattle2(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The sisters lower their weapons, satisfied. 'You are ready for what comes next.'");
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
            Console.WriteLine("The city is barely recognizable. Half the market district is ash and the rest is on its way. Citizens push past in a panic, moving in every direction at once.");
            Console.WriteLine("The ground trembles beneath their feet. Whatever is coming, it's close.");
            Console.WriteLine("A familiar voice cuts through the chaos — the same one that spoke across a corner booth so many nights ago, that warned of a darkness taking root.");
            Console.WriteLine("'You have proven yourself.'");
            Console.WriteLine("A second voice, eerily similar to the first, adds, 'We will help, after you pass our final test.'");
            Console.WriteLine("The stranger who sent them on this journey steps out from the shadows and pulls back her hood.");
            Console.WriteLine("Beside her stands her sister, doing the same.");
            Console.WriteLine("One channels the power of nature, commanding vine and root. The other wields the forces of death and decay.");
            Console.WriteLine("They ready themselves and the final test begins.");
        }
    }
}
