using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Pickpocket : BaseFighter
    {
        public Pickpocket(int level = 1)
        {
            Level = level;
            Health = Stat(34, 43, 2, 5);
            MaxHealth = Health;
            PhysicalAttack = Stat(12, 16, 1, 3);
            PhysicalDefense = Stat(5, 8, 0, 2);
            MagicAttack = Stat(2, 4, 0, 1);
            MagicDefense = Stat(5, 9, 0, 2);
            Speed = Stat(22, 28, 2, 3);
            Abilities = new List<Ability>() { new QuickStab(), new Pilfer() };
            CharacterType = "Pickpocket";
            Mana = Stat(5, 9, 1, 3);
            MaxMana = Mana;
            CritChance = 15;
            CritDamage = 1;
            DodgeChance = 20;
        }

        public Pickpocket(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Pickpocket(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(2, 5);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(0, 2);
            MagicAttack += random.Next(0, 1);
            MagicDefense += random.Next(0, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
