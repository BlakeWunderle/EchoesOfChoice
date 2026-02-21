using EchoesOfChoice.CharacterClasses.Abilities.Enemy;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Nymph : BaseFighter
    {
        public Nymph(int level = 4)
        {
            Level = level;
            Health = Stat(70, 89, 5, 9, 4);
            MaxHealth = Health;
            PhysicalAttack = Stat(7, 11, 1, 2, 4);
            PhysicalDefense = Stat(9, 16, 1, 3, 4);
            MagicAttack = Stat(24, 32, 3, 5, 4);
            MagicDefense = Stat(15, 22, 2, 4, 4);
            Speed = Stat(18, 25, 2, 4, 4);
            Abilities = new List<Ability>() { new NaturesWrath(), new Charm() };
            CharacterType = "Nymph";
            Mana = Stat(24, 40, 2, 5, 4);
            MaxMana = Mana;
            CritChance = 1;
            CritDamage = 1;
            DodgeChance = 2;
        }

        public Nymph(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Nymph(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
            var healthIncrease = random.Next(5, 9);
            Health += healthIncrease;
            MaxHealth += healthIncrease;
            var manaIncrease = random.Next(2, 5);
            Mana += manaIncrease;
            MaxMana += manaIncrease;
            PhysicalAttack += random.Next(1, 2);
            PhysicalDefense += random.Next(1, 3);
            MagicAttack += random.Next(3, 5);
            MagicDefense += random.Next(2, 4);
            Speed += random.Next(2, 4);
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
