using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Warlock : BaseFighter
    {
        public Warlock()
        {
            Abilities = new List<Ability>() { new ShadowBolt(), new Curse(), new DrainLife() };
            CharacterType = "Warlock";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 2;
        }

        public Warlock(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Warlock(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 5;
            MagicDefense += 3;
            Speed += 2;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(3, 6);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
