using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Duelist : BaseFighter
    {
        public Duelist()
        {
            Abilities = new List<Ability>() { new Slash(), new Feint() };
            CharacterType = "Duelist";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Horse, UpgradeItemEnum.Spear };
        }

        public Duelist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Duelist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 4;
            MaxHealth += 4;
            PhysicalAttack += 3;
            PhysicalDefense += 2;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(9, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 6);
            PhysicalDefense += random.Next(2, 5);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Horse:
                    {
                        var upgradedUnit = new Cavalry();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Spear:
                    {
                        var upgradedUnit = new Dragoon();
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
