using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Ruffian : BaseFighter
    {
        public Ruffian(int level = 1)
        {
            Level = level;
            Health = Stat(44, 54, 3, 6);
            MaxHealth = Health;
            PhysicalAttack = Stat(16, 20, 1, 3);
            PhysicalDefense = Stat(7, 11, 1, 2);
            MagicAttack = Stat(2, 5, 0, 1);
            MagicDefense = Stat(6, 10, 1, 2);
            Speed = Stat(16, 22, 1, 2);
            Abilities = new List<Ability>() { new Haymaker(), new Intimidate() };
            CharacterType = "Ruffian";
            Mana = Stat(4, 8, 1, 3);
            MaxMana = Mana;
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 5;
        }

        public Ruffian(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Ruffian(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(3, 6);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(1, 2);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
