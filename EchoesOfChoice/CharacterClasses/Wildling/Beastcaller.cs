using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Beastcaller : BaseFighter
    {
        public Beastcaller()
        {
            Abilities = new List<Ability>() { new FeralStrike(), new PackHowl() };
            CharacterType = "Beastcaller";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Feather, UpgradeItemEnum.Pelt };
        }

        public Beastcaller(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Beastcaller(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 4;
            MaxHealth += 4;
            PhysicalAttack += 3;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(7, 10);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Feather:
                    {
                        var upgradedUnit = new Falconer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Pelt:
                    {
                        var upgradedUnit = new Shapeshifter();
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
