using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Tinker : BaseFighter
    {
        public Tinker()
        {
            Abilities = new List<Ability>() { new Trap(), new SpringLoaded() };
            CharacterType = "Tinker";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Dynamite, UpgradeItemEnum.Brick };
        }

        public Tinker(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Tinker(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 5;
            MaxHealth += 5;
            PhysicalDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(11, 14);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(3, 6);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.Brick:
                    {
                        var upgradedUnit = new Siegemaster();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Dynamite:
                    {
                        var upgradedUnit = new Bombardier();
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
