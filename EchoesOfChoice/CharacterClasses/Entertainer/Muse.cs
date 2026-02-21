using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Muse : BaseFighter
    {
        public Muse()
        {
            Abilities = new List<Ability>() { new Lullaby(), new Vocals(), new SoothingMelody() };
            CharacterType = "Muse";
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 1;
        }

        public Muse(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Muse(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            MagicAttack += 8;
            Mana += 8;
            MaxMana += 8;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(4, 7);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(4, 7);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(2, 4);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(4, 7);
            MagicDefense += random.Next(3, 6);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
