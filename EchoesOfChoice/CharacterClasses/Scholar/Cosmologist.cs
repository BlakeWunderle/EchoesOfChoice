using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Cosmologist : BaseFighter
    {
        public Cosmologist()
        {
            Abilities = new List<Ability>() { new TimeWarp(), new BlackHole(), new Gravity() };
            CharacterType = "Philosopher";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.TimeMachine, UpgradeItemEnum.Telescope };
        }

        public Cosmologist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Cosmologist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 3;
            MaxHealth += 3;
            MagicAttack += 4;
            Speed += 3;
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
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.TimeMachine:
                    {
                        var upgradedUnit = new Chronomancer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Telescope:
                    {
                        var upgradedUnit = new Astronomer();
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
