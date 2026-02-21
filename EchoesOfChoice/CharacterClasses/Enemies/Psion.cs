using EchoesOfChoice.CharacterClasses.Abilities;
using EchoesOfChoice.CharacterClasses.Common;
using System.Collections.Generic;

namespace EchoesOfChoice.CharacterClasses.Enemies
{
    public class Psion : BaseFighter
    {
        public Psion(int level = 10)
        {
            Level = level;
            Health = Stat(108, 140, 5, 10, 10);
            MaxHealth = Health;
            PhysicalAttack = Stat(22, 33, 1, 3, 10);
            PhysicalDefense = Stat(21, 32, 1, 3, 10);
            MagicAttack = Stat(63, 79, 6, 9, 10);
            MagicDefense = Stat(30, 41, 2, 4, 10);
            Speed = Stat(34, 45, 2, 4, 10);
            Abilities = new List<Ability>() { new Mindblast(), new Telekinesis(), new Confuse() };
            CharacterType = "Psion";
            Mana = Stat(52, 73, 4, 7, 10);
            MaxMana = Mana;
            CritChance = 2;
            CritDamage = 2;
            DodgeChance = 2;
        }

        public Psion(BaseFighter fighter) : base(fighter) { }

        public override BaseFighter Clone()
        {
            return new Psion(this);
        }

        public override void IncreaseLevel()
        {
            Level += 1;
        }

        public override BaseFighter UpgradeClass(UpgradeItemEnum upgradeItem)
        {
            throw new System.NotImplementedException();
        }
    }
}
