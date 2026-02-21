using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class MartialArtist : BaseFighter
    {
        public MartialArtist()
        {
            Abilities = new List<Ability>() { new Punch(), new Topple() };
            CharacterType = "Martial Artist";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 2;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Sword, UpgradeItemEnum.Staff };
        }

        public MartialArtist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new MartialArtist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 4;
            MaxHealth += 4;
            Speed += 3;
            PhysicalAttack += 2;
            PhysicalDefense += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(12, 15);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 6);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Sword:
                    {
                        var upgradedUnit = new Ninja();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Staff:
                    {
                        var upgradedUnit = new Monk();
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
