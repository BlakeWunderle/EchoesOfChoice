using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Orator : BaseFighter
    {
        public Orator()
        {
            Abilities = new List<Ability>() { new Oration(), new Encourage() };
            CharacterType = "Orator";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Medal, UpgradeItemEnum.Pen };
        }

        public Orator(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Orator(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicDefense += 3;
            MagicAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Pen:
                    {
                        var upgradedUnit = new Elegist();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Medal:
                    {
                        var upgradedUnit = new Laureate();
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
