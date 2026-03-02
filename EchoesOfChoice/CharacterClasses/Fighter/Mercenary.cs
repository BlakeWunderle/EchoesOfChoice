using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;
using System;

namespace EchoesOfChoice.CharacterClasses.Fighter
{
    public class Mercenary : BaseFighter
    {
        public Mercenary()
        {
            Abilities = new List<Ability>() { new GunShot(), new CalledShot(), new QuickDraw() };
            CharacterType = "Mercenary";
            CritChance = 40;
            CritDamage = 7;
            DodgeChance = 10;
        }
        public Mercenary(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Mercenary(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 7;
            Speed += 5;
            Health += 5;
            MaxHealth += 5;
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
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
