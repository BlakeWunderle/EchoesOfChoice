using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Shaman : BaseFighter
    {
        public Shaman()
        {
            Abilities = new List<Ability>() { new SpectralLance(), new Hex() };
            CharacterType = "Shaman";
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 10;
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Shrunkenhead, UpgradeItemEnum.SpiritOrb };
        }

        public Shaman(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shaman(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 6;
            MaxHealth += 6;
            MagicAttack += 4;
            PhysicalAttack += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Shrunkenhead:
                    {
                        var upgradedUnit = new WitchDoctor();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.SpiritOrb:
                    {
                        var upgradedUnit = new Spiritwalker();
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
