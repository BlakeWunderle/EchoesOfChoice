using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Invoker : BaseFighter
    {
        public Invoker()
        {
            Abilities = new List<Ability>() { new ArcaneBolt(), new ElementalSurge() };
            CharacterType = "Invoker";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.FireStone, UpgradeItemEnum.WaterStone, UpgradeItemEnum.LightningStone };
        }

        public Invoker(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Invoker(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 3;
            MaxHealth += 3;
            MagicAttack += 3;
            MagicDefense += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.FireStone:
                    {
                        var upgradedUnit = new Infernalist();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.WaterStone:
                    {
                        var upgradedUnit = new Tidecaller();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.LightningStone:
                    {
                        var upgradedUnit = new Tempest();
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
