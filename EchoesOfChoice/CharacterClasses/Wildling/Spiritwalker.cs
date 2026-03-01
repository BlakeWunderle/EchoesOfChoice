using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Spiritwalker : BaseFighter
    {
        public Spiritwalker()
        {
            Abilities = new List<Ability>() { new SpiritShield(), new AncestralBlessing(), new SpiritMend() };
            CharacterType = "Spiritwalker";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Spiritwalker(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Spiritwalker(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicDefense += 4;
            MagicAttack += 2;
            Health += 3;
            MaxHealth += 3;
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
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
