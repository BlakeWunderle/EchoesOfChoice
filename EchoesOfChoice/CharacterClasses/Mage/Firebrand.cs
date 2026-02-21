using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Firebrand : BaseFighter
    {
        public Firebrand()
        {
            Abilities = new List<Ability>() { new Fire(), new Scorch() };
            CharacterType = "Firebrand";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.FireStone, UpgradeItemEnum.LavaStone };
        }

        public Firebrand(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Firebrand(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 4;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 2);
            MagicAttack += random.Next(6, 9);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.LavaStone:
                    {
                        var upgradedUnit = new Geomancer();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.FireStone:
                    {
                        var upgradedUnit = new Pyromancer();
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
