using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Enemies;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.Battles
{
    public class ReturnToCityBattle3 : Battle
    {
        private List<BaseFighter> selectableEnemies = new List<BaseFighter>();

        public ReturnToCityBattle3(List<BaseFighter> units) : base(units)
        {
            Enemies = new List<BaseFighter>()
            {
                new Psion() { CharacterName = "Elan" },
                new Runewright() { CharacterName = "Nale" }
            };

            foreach (var unit in Enemies)
            {
                var selectableEnemy = unit.Clone();
                selectableEnemy.IsUserControlled = true;
                selectableEnemies.Add(selectableEnemy);
            }

            var elan = selectableEnemies[0];
            elan.Health -= 10; elan.MaxHealth -= 10;
            elan.MagicAttack -= 8;

            var nale = selectableEnemies[1];
            nale.Health += 5; nale.MaxHealth += 5;
            nale.MagicAttack += 6; nale.PhysicalAttack += 4;

            IsFinalBattle = false;
        }

        public override void DetermineNextBattle()
        {
            NextBattle = new ElementalBattle3(Units);
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
            Console.WriteLine("The gates are gone — blasted off their hinges. Inside, the city is chaos: overturned carts, broken glass, people shouting names into the smoke.");
            Console.WriteLine("The ground trembles beneath their feet. Whatever is coming, it's close.");
            Console.WriteLine("A familiar voice cuts through the chaos — the same one that spoke across a corner booth so many nights ago, that warned of a darkness taking root.");
            Console.WriteLine("'You have proven yourself.'");
            Console.WriteLine("A second voice, eerily similar to the first, adds, 'We will help, after you pass our final test.'");
            Console.WriteLine("The stranger who sent them on this journey steps out from the shadows and pulls back his hood.");
            Console.WriteLine("Beside him stands his companion, doing the same.");
            Console.WriteLine("One's eyes glow with psychic energy, hurling objects with his mind. The other traces glowing runes in the air.");
            Console.WriteLine("They ready themselves and the final test begins.");
        }
    }
}
