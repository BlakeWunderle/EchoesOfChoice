using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Scholar
{
    public class Thaumaturge : BaseFighter
    {
        public Thaumaturge()
        {
            Abilities = new List<Ability>() { new RunicStrike(), new ArcaneWard(), new RunicBlast() };
            CharacterType = "Thaumaturge";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Thaumaturge(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Thaumaturge(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 8;
            MaxHealth += 8;
            MagicAttack += 5;
            PhysicalDefense += 3;
            MagicDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(10, 13);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(5, 8);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(3, 5);
            PhysicalDefense += random.Next(4, 7);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(4, 7);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
