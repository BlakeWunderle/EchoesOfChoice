using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Warden : BaseFighter
    {
        public Warden()
        {
            Abilities = new List<Ability>() { new Block(), new ShieldBash() };
            CharacterType = "Warden";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Sword, UpgradeItemEnum.Helmet };
        }

        public Warden(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Warden(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 10;
            MaxHealth += 10;
            PhysicalDefense += 4;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(14, 17);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 5);
            PhysicalDefense += random.Next(3, 6);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Sword:
                    {
                        var upgradedUnit = new Knight();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Helmet:
                    {
                        var upgradedUnit = new Bastion();
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
