using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Stormcaller : BaseFighter
    {
        public Stormcaller()
        {
            Abilities = new List<Ability>() { new Lightning(), new Gust() };
            CharacterType = "Stormcaller";
            CritChance = 3;
            CritDamage = 2;
            DodgeChance = 2;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.LightningStone, UpgradeItemEnum.AirStone };
        }

        public Stormcaller(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Stormcaller(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 3;
            Speed += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.LightningStone:
                    {
                        var upgradedUnit = new Electromancer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.AirStone:
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
