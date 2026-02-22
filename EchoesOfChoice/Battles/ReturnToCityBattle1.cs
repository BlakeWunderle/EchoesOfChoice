using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ReturnToCityBattle1 : Battle
    {
        private List<BaseFighter> selectableEnemies = new List<BaseFighter>();

        public ReturnToCityBattle1(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Seraph() { CharacterName = "Sera" },
                new Fiend() { CharacterName = "Ares" }
            };

            foreach (var unit in Enemies)
            {
                var selectableEnemy = unit.Clone();
                selectableEnemy.IsUserControlled = true;
                selectableEnemies.Add(selectableEnemy);
            }

            var sera = selectableEnemies[0];
            sera.Health -= 20; sera.MaxHealth -= 20;
            sera.MagicAttack -= 7; sera.PhysicalAttack -= 5;

            var ares = selectableEnemies[1];
            ares.Health += 20; ares.MaxHealth += 20;
            ares.MagicAttack += 5; ares.PhysicalAttack += 7;

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ElementalBattle1(Units);
        }

        public override void PostBattleInteraction()
        {
            Console.WriteLine();
            Console.WriteLine("The brothers lower their weapons, satisfied. 'You are ready for what comes next.'");
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
            Console.WriteLine("A familiar voice cuts through the chaos — the same one that spoke across a corner booth so many nights ago, that warned of a darkness taking root.");
            Console.WriteLine("'You have proven yourself.'");
            Console.WriteLine("A second voice, eerily similar to the first, adds, 'We will help, after you pass our final test.'");
            Console.WriteLine("The stranger who sent them on this journey steps out from the shadows and pulls back his hood.");
            Console.WriteLine("Beside him stands his brother, doing the same.");
            Console.WriteLine("One radiates a blinding holy light, a celestial warrior of divine power. The other smolders with infernal flame, a demon lord of unmatched fury.");
            Console.WriteLine("They ready themselves and the final test begins.");
        }
    }
}
