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
            CritChance = 10;
            CritDamage = 1;
            DodgeChance = 10;
        }

        public Spiritwalker(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Spiritwalker(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicDefense += 6;
            MagicAttack += 6;
            Health += 10;
            MaxHealth += 10;
            Speed += 4;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(4, 6);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
