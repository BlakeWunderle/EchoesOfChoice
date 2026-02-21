using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Bombardier : BaseFighter
    {
        public Bombardier()
        {
            Abilities = new List<Ability>() { new Shrapnel(), new Explosion(), new Detonate() };
            CharacterType = "Bombardier";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Bombardier(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Bombardier(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 5;
            Health += 8;
            MaxHealth += 8;
            PhysicalDefense += 3;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(14, 17);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(6, 9);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(3, 6);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
