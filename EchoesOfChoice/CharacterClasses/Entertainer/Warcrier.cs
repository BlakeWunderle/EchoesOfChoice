using EchoesOfChoice.CharacterClasses.Common;
using EchoesOfChoice.CharacterClasses.Abilities;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Entertainer
{
    public class Warcrier : BaseFighter
    {
        public Warcrier()
        {
            Abilities = new List<Ability>() { new BattleCry(), new Smash(), new Encore() };
            CharacterType = "Warcrier";
            CritChance = 3;
            CritDamage = 3;
            DodgeChance = 2;
        }
        public Warcrier(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Warcrier(this);
        }

        protected override void ApplyUpgradeBonuses()
        {
            Health += 8;
            MaxHealth += 8;
            PhysicalAttack += 5;
            PhysicalDefense += 3;
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(9, 12);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(4, 7);
            PhysicalDefense += random.Next(2, 4);
            MagicAttack += random.Next(2, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 5);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
