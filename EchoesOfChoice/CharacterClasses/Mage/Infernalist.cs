using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Mage
{
    public class Infernalist : BaseFighter
    {
        public Infernalist()
        {
            Abilities = new List<Ability>() { new FireBall(), new Inferno(), new Enrage() };
            CharacterType = "Infernalist";
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 3;
        }

        public Infernalist(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Infernalist(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 5;
            Speed += 3;
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
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
