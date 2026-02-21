using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Chorister : BaseFighter
    {
        public Chorister()
        {
            Abilities = new List<Ability>() { new Melody(), new Sing(), new Encore() };
            CharacterType = "Chorister";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Trumpet, UpgradeItemEnum.Lyre };
        }

        public Chorister(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Chorister(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 3;
            Mana += 5;
            MaxMana += 5;
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
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Trumpet:
                    {
                        var upgradedUnit = new Herald();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Lyre:
                    {
                        var upgradedUnit = new Muse();
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
