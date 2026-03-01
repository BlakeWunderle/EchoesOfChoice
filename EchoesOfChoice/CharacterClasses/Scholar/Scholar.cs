using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Scholar : BaseFighter
    {
        public Scholar()
        {
            Level = 1;
            Health = random.Next(40, 47);
            MaxHealth = Health;
            PhysicalAttack = random.Next(7, 10);
            PhysicalDefense = random.Next(10, 13);
            MagicAttack = random.Next(15, 20);
            MagicDefense = random.Next(15, 20);
            Speed = random.Next(10, 15);
            Abilities = new List<Ability>() { new Proof(), new EnergyBlast() };
            CharacterType = "Tinker";
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Crystal, UpgradeItemEnum.Textbook, UpgradeItemEnum.Abacus };
            Mana = random.Next(10, 17);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Scholar(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Scholar(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Crystal:
                    {
                        var upgradedUnit = new Artificer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Textbook:
                    {
                        var upgradedUnit = new Cosmologist();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Abacus:
                    {
                        var upgradedUnit = new Arithmancer();
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
