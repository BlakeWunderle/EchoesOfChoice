using EchoesOfChoice.CharacterClasses.Common;

namespace EchoesOfChoice.CharacterClasses.Abilities
{
    public class Decay : Ability
    {
        public Decay()
        {
            Name = "Decay";
            FlavorText = "A wave of necrotic energy causes the enemy's defenses to wither and rot.";
            ModifiedStat = StatEnum.Defense;
            Modifier = 5;
            impactedTurns = 2;
            UseOnEnemy = true;
            ManaCost = 3;
        }
    }
}
