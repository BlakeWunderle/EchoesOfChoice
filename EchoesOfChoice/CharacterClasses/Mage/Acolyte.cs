using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Acolyte : BaseFighter
    {
        public Acolyte()
        {
            Abilities = new List<Ability>() { new Cure(), new Protect(), new Radiance() };
            CharacterType = "Acolyte";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Hammer, UpgradeItemEnum.HolyBook };
        }

        public Acolyte(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Acolyte(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 3;
            MaxHealth += 3;
            MagicDefense += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Hammer:
                    {
                        var upgradedUnit = new Paladin();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.HolyBook:
                    {
                        var upgradedUnit = new Priest();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                default:
                    {
                        throw new Exception("How the fuck did you get that upgrade item!");
                    }
            }
        }
    }
}
