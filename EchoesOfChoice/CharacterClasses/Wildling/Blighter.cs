using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Blighter : BaseFighter
    {
        public Blighter()
        {
            Abilities = new List<Ability>() { new Blight(), new LifeSiphon(), new PoisonSting() };
            CharacterType = "Blighter";
            CritChance = 10;
            CritDamage = 2;
            DodgeChance = 10;
        }

        public Blighter(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Blighter(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 7;
            Health += 8;
            MaxHealth += 8;
            MagicDefense += 3;
            Speed += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(7, 11);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(5, 8);
            MagicDefense += random.Next(3, 5);
            Speed += random.Next(2, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
