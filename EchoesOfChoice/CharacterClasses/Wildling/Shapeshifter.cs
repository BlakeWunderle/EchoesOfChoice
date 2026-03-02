using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Shapeshifter : BaseFighter
    {
        public Shapeshifter()
        {
            Abilities = new List<Ability>() { new SavageMaul(), new Frenzy(), new PrimalRoar() };
            CharacterType = "Shapeshifter";
            CritChance = 20;
            CritDamage = 3;
            DodgeChance = 20;
        }

        public Shapeshifter(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shapeshifter(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 14;
            Health += 16;
            MaxHealth += 16;
            PhysicalDefense += 5;
            Speed += 6;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(12, 16);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(8, 11);
            PhysicalDefense += random.Next(4, 6);
            MagicAttack += random.Next(1, 3);
            MagicDefense += random.Next(1, 3);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
