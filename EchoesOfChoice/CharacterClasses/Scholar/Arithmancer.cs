using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Arithmancer : BaseFighter
    {
        public Arithmancer()
        {
            Abilities = new List<Ability>() { new Recite(), new Calculate() };
            CharacterType = "Arithmancer";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.ClockworkCore, UpgradeItemEnum.Computer };
        }

        public Arithmancer(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Arithmancer(this);
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
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {

            switch (upgradeItem)
            {
                case UpgradeItemEnum.ClockworkCore:
                    {
                        var upgradedUnit = new Automaton();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Computer:
                    {
                        var upgradedUnit = new Technomancer();
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
