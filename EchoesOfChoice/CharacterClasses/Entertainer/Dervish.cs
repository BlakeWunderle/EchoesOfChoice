using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Dervish : BaseFighter
    {
        public Dervish()
        {
            Abilities = new List<Ability>() { new Seduce(), new Dance() };
            CharacterType = "Dervish";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Light, UpgradeItemEnum.Paint };
        }
        public Dervish(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Dervish(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Speed += 4;
            PhysicalAttack += 2;
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
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(4, 7);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Light:
                    {
                        var upgradedUnit = new Illusionist();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Paint:
                    {
                        var upgradedUnit = new Mime();
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
