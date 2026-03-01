using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Wildling : BaseFighter
    {
        public Wildling()
        {
            Level = 1;
            Health = random.Next(41, 50);
            MaxHealth = Health;
            PhysicalAttack = random.Next(10, 14);
            PhysicalDefense = random.Next(10, 14);
            MagicAttack = random.Next(12, 16);
            MagicDefense = random.Next(12, 16);
            Speed = random.Next(10, 13);
            Abilities = new List<Ability>() { new ThornWhip(), new BarkSkin() };
            CharacterType = "Wildling";
            UpgradeItems = new List<UpgradeItemEnum>() { UpgradeItemEnum.Herbs, UpgradeItemEnum.Totem, UpgradeItemEnum.BeastClaw };
            Mana = random.Next(8, 12);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Wildling(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Wildling(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(6, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(2, 4);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            switch (upgradeItem)
            {
                case UpgradeItemEnum.Herbs:
                    {
                        var upgradedUnit = new Herbalist();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.Totem:
                    {
                        var upgradedUnit = new Shaman();
                        upgradedUnit.KeepStatsOnUpgrade(this);
                        return upgradedUnit;
                    }
                case UpgradeItemEnum.BeastClaw:
                    {
                        var upgradedUnit = new Beastcaller();
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
