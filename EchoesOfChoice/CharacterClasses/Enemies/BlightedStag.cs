using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class BlightedStag : BaseFighter
    {
        public BlightedStag(int level = 17)
        {
            Level = level;
            Health = Stat(270, 310, 7, 10, 17);
            MaxHealth = Health;
            PhysicalAttack = Stat(56, 64, 3, 5, 17);
            PhysicalDefense = Stat(26, 32, 2, 4, 17);
            MagicAttack = Stat(24, 30, 2, 3, 17);
            MagicDefense = Stat(24, 30, 2, 3, 17);
            Speed = Stat(38, 44, 3, 5, 17);
            Abilities = new List<Ability>() { new AntlerCharge(), new RotAura(), new Blight() };
            CharacterType = "Blighted Stag";
            Mana = Stat(28, 34, 2, 4, 17);
            MaxMana = Mana;
            CritChance = 19;
            CritDamage = 4;
            DodgeChance = 20;
        }

        public BlightedStag(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new BlightedStag(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 2);
            MagicDefense += random.Next(1, 2);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
