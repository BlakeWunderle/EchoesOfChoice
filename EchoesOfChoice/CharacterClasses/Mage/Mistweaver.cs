using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Mistweaver : BaseFighter
    {
        public Mistweaver()
        {
            Abilities = new List<Ability>() { new Ice(), new Chill() };
            CharacterType = "Mistweaver";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.WaterStone, UpgradeItemEnum.IceStone };
        }

        public Mistweaver(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Mistweaver(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 3;
            MagicDefense += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.IceStone:
                    {
                        var upgradedUnit = new Cryomancer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.WaterStone:
                    {
                        var upgradedUnit = new Hydromancer();
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
