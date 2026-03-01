using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Wildling
{
    public class Blighter : BaseFighter
    {
        public Blighter()
        {
            Abilities = new List<Ability>() { new Blight(), new Wither(), new Miasma() };
            CharacterType = "Blighter";
            CritChance = 1;
            CritDamage = 2;
            DodgeChance = 1;
        }

        public Blighter(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Blighter(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 4;
            Health += 3;
            MaxHealth += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 8);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 4);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 3);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(1, 3);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
