using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Alchemist : BaseFighter
    {
        public Alchemist()
        {
            Abilities = new List<Ability>() { new Transmute(), new VialToss(), new Elixir() };
            CharacterType = "Alchemist";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Alchemist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Alchemist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 5;
            MaxHealth += 5;
            PhysicalAttack += 5;
            MagicAttack += 5;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            MagicAttack += random.Next(5, 8);
            var manaIncrease = random.Next(7, 10);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(5, 8);
            PhysicalDefense += random.Next(2, 4);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
