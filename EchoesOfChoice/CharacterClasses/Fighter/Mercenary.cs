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
            CritChance = 4;
            CritDamage = 7;
            DodgeChance = 1;
        }
        public Mercenary(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Mercenary(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 5;
            Speed += 3;
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
            Speed += random.Next(3, 6);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
                throw new NotImplementedException();
        }
    }
}
