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
            CritChance = 1;
            CritDamage = 3;
            DodgeChance = 1;
        }

        public Shapeshifter(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Shapeshifter(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            PhysicalAttack += 5;
            Health += 4;
            MaxHealth += 4;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(8, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(1, 3);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(2, 4);
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
